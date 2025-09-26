import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import fetch from "node-fetch";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const upload = multer(); // handles multipart/form-data

// serve static files (your index6.html should be inside public folder)
app.use(express.static(path.join(__dirname, "Public")));

// route for form submission
app.post("/generate", upload.none(), async (req, res) => {
  try {
    // 1. Collect IDs + replace in template
    const ids = [];
    for (let i = 1; i <= 10; i++) {
      ids.push(req.body[`client${i}`] || "");
    }

    let template = fs.readFileSync(path.join(__dirname, "template.ahk"), "utf-8");
    ids.forEach((id, index) => {
      template = template.replace(new RegExp(`{{ID${index + 1}}}`, "g"), id);
    });

    const filename = `generated_${Date.now()}.ahk`;

    // 2. Upload .ahk to GitHub
    const repo = "YOUR_USERNAME/YOUR_REPO"; // 🔹 change
    const branch = "main";
    const apiUrl = `https://api.github.com/repos/${repo}/contents/scripts/${filename}`;

    const uploadResp = await fetch(apiUrl, {
      method: "PUT",
      headers: {
        "Authorization": `token ${process.env.GITHUB_TOKEN}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: `Add ${filename} from Render server`,
        content: Buffer.from(template).toString("base64"),
        branch,
      }),
    });

    if (!uploadResp.ok) {
      const err = await uploadResp.json();
      return res.status(500).json({ error: "GitHub upload failed", details: err });
    }

    // 3. Poll GitHub Release API until exe is ready
    const tag = filename.replace(".ahk", "");
    const releaseUrl = `https://api.github.com/repos/${repo}/releases/tags/${tag}`;

    let exeUrl = null;
    for (let attempt = 0; attempt < 30; attempt++) { // ~30 tries (e.g. 60s)
      const r = await fetch(releaseUrl, {
        headers: { "Authorization": `token ${process.env.GITHUB_TOKEN}` }
      });

      if (r.ok) {
        const release = await r.json();
        const asset = release.assets.find(a => a.name.endsWith(".exe"));
        if (asset) {
          exeUrl = asset.browser_download_url;
          break;
        }
      }
      await new Promise(resolve => setTimeout(resolve, 2000)); // wait 2s
    }

    if (!exeUrl) {
      return res.status(500).json({ error: "Timed out waiting for EXE" });
    }

    // 4. Redirect user straight to download
    res.redirect(exeUrl);

  } catch (err) {
    console.error("Error in /generate:", err);
    res.status(500).json({ error: "Server error", details: err.message });
  }
});
// start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});

