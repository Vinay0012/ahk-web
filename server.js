import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const upload = multer(); // handles multipart/form-data

// serve static files (your index6.html should be inside public folder)
app.use(express.static(path.join(__dirname, "public")));

// route for form submission
app.post("/generate", upload.none(), (req, res) => {
  console.log("Received body:", req.body);

  // collect all client IDs
  const ids = [];
  for (let i = 1; i <= 10; i++) {
    ids.push(req.body[`client${i}`] || "");
  }

  // load template
  const templatePath = path.join(__dirname, "template.ahk");
  let template = fs.readFileSync(templatePath, "utf-8");

  // replace placeholders {{ID1}}, {{ID2}}, ...
  ids.forEach((id, index) => {
    template = template.replace(`{{ID${index + 1}}}`, id);
  });

  // write new script
  const outputDir = path.join(__dirname, "output");
  if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

  const outputPath = path.join(outputDir, `generated_${Date.now()}.ahk`);
  fs.writeFileSync(outputPath, template);

  // send file for download
  res.download(outputPath, "custom_script.ahk", (err) => {
    if (err) console.error("Download error:", err);
  });
});

// start server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});