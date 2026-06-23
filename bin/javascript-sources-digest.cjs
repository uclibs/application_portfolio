#!/usr/bin/env node

const crypto = require("crypto")
const fs = require("fs")
const path = require("path")

const root = path.join(__dirname, "..")
const digest = crypto.createHash("sha256")
const inputs = [path.join(root, "package.json")]

const javascriptDir = path.join(root, "app/javascript")
for (const entry of fs.readdirSync(javascriptDir)) {
  const filePath = path.join(javascriptDir, entry)
  if (fs.statSync(filePath).isFile() && filePath.endsWith(".js")) {
    inputs.push(filePath)
  }
}

inputs.sort((left, right) =>
  path.relative(root, left).localeCompare(path.relative(root, right))
)

for (const filePath of inputs) {
  const relativePath = path.relative(root, filePath)
  digest.update(`${relativePath}:`)
  digest.update(fs.readFileSync(filePath))
}

const outputPath = path.join(root, "app/assets/builds/application.js.sources.sha256")
fs.writeFileSync(outputPath, `${digest.digest("hex")}\n`)
