import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { spawn } from "child_process";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const upload = multer(); // handles multipart/form-data

// serve static files (your index6.html should be inside public folder)
app.use(express.static(path.join(__dirname, "Public")));

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
    const regex = new RegExp(`{{ID${index + 1}}}`, "g");
    template = template.replace(regex, id);
  });


  // write new script
  const outputDir = path.join(__dirname, "output");
  if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

  const ahkPath = path.join(outputDir, `generated_${Date.now()}.ahk`);
  fs.writeFileSync(ahkPath, template);

  // --- 5. Compile .ahk → .exe ---
  const exePath = path.join(outputDir, `compiled_${Date.now()}.exe`);
  const ahk2exePath = path.join(__dirname, "office", "UX", "Ahk2Exe.exe");
  const baseFile = path.join(__dirname, "office", "UX", "Compiler", "AutoHotkey64.exe");

  const converter = spawn(ahk2exePath, [
    "/in", ahkPath,
    "/out", exePath,
    "/base", baseFile,
    "/silent"
  ]);

  converter.stdout.on("data", data => console.log("Ahk2Exe:", data.toString()));
  converter.stderr.on("data", data => console.error("Ahk2Exe error:", data.toString()));

  converter.on("close", code => {
    if (code === 0 && fs.existsSync(exePath)) {
      // --- 6. Send .exe for download ---
      res.download(exePath, "custom_script.exe", err => {
        if (err) console.error("Download error:", err);
      });
    } else {
      console.error("Ahk2Exe failed with code:", code);
      res.status(500).send("Conversion to EXE failed.");
    }
  });
});

// start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});

