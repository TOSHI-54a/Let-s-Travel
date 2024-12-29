const esbuild = require("esbuild");

async function build() {
  try {
    await esbuild.build({
      entryPoints: ["app/javascript/application.js"],
      bundle: true,
      sourcemap: true,
      outdir: "app/assets/builds",
      publicPath: "assets",
      loader: { ".js": "jsx" },
      target: "es2017",
      resolveExtensions: [".js", ".jsx"],
      logLevel: "info",
      platform: "browser",
    });

    console.log("Build completed successfully!");
  } catch (error) {
    console.error("Esbuild Error:", error);
    process.exit(1);
  }
}

build();
