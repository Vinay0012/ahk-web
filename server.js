import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { Octokit } from "@octokit/rest";
import AdmZip from "adm-zip";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const upload = multer();
app.use(express.static(path.join(__dirname, "Public")));

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const REPO_OWNER = "Vinay0012";
const REPO_NAME = "office";
const WORKFLOW_FILE = "version5.yml";

const octokit = new Octokit({ auth: GITHUB_TOKEN });

app.post("/generate", upload.none(), async (req, res) => {
  try {
    // 1️⃣ Collect client IDs
    const ids = [];
    for (let i = 1; i <= 20; i++) ids.push(req.body[`client${i}`] || "");

    // 2️⃣ Load template
    const templatePath = path.join(__dirname, "template.ahk");
    let template = fs.readFileSync(templatePath, "utf-8");
    ids.forEach((id, index) => {
      const regex = new RegExp(`{{ID${index + 1}}}`, "g");
      template = template.replace(regex, id);
    });

    // 3️⃣ Save generated AHK locally
    const outputDir = path.join(__dirname, "output");
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);
    const ahkFileName = `generated_${Date.now()}.ahk`;
    const ahkFilePath = path.join(outputDir, ahkFileName);
    fs.writeFileSync(ahkFilePath, template);

    // 4️⃣ Push AHK to GitHub
    const content = fs.readFileSync(ahkFilePath, { encoding: "base64" });
    await octokit.repos.createOrUpdateFileContents({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      path: `scripts/${ahkFileName}`,
      message: `Add generated AHK ${ahkFileName}`,
      content,
    });

    // 5️⃣ Trigger workflow_dispatch
    await octokit.actions.createWorkflowDispatch({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      workflow_id: WORKFLOW_FILE,
      ref: "main",
      inputs: { script_name: ahkFileName },
    });

    // 6️⃣ Poll workflow for artifact
    let exeUrl = null;
    const maxAttempts = 30; // 2.5 minutes
    for (let attempt = 0; attempt < maxAttempts; attempt++) {
      await new Promise(r => setTimeout(r, 5000));

      const runs = await octokit.actions.listWorkflowRuns({
        owner: REPO_OWNER,
        repo: REPO_NAME,
        workflow_id: WORKFLOW_FILE,
        event: "workflow_dispatch",
      });

      const latestRun = runs.data.workflow_runs[0];
      if (!latestRun) continue;

      if (latestRun.status === "completed" && latestRun.conclusion === "success") {
        const artifacts = await octokit.actions.listWorkflowRunArtifacts({
          owner: REPO_OWNER,
          repo: REPO_NAME,
          run_id: latestRun.id,
        });

        if (artifacts.data.artifacts.length > 0) {
          exeUrl = artifacts.data.artifacts[0].archive_download_url;
          break;
        }
      }
    }

    if (!exeUrl) return res.status(500).send("Failed to generate EXE in time.");

    // 7️⃣ Download artifact (zip) and extract EXE using native fetch
    const artifactResp = await fetch(exeUrl, {
      headers: { Authorization: `token ${GITHUB_TOKEN}` },
    });
    const buffer = Buffer.from(await artifactResp.arrayBuffer());
    const zip = new AdmZip(buffer);
    zip.extractAllTo(outputDir, true);

    const exePath = path.join(outputDir, "hello.exe"); // matches workflow output

    // 8️⃣ Send EXE to user
    res.download(exePath, "KFS Multiple Clients.exe", () => {
      fs.unlinkSync(ahkFilePath);
      fs.unlinkSync(exePath);
    });

  } catch (err) {
    console.error(err);
    res.status(500).send("Error generating EXE.");
  }
});

app.listen(3000, () => console.log("Server running on port 3000"));
