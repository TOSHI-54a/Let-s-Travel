const esbuild = require("esbuild");
const { sassPlugin } = require("esbuild-sass-plugin");

esbuild
  .build({
    entryPoints: ["app/javascript/application.js", "app/assets/stylesheets/application.scss"],
    bundle: true,
    sourcemap: true,
    outdir: "app/assets/builds",
    publicPath: "assets",
    loader: { ".js": "jsx", ".scss": "css" },
    plugins: [sassPlugin()],
    target: "es2017",
    resolveExtensions: [".js", ".jsx", ".scss"],
    logLevel: "info",
    platform: "browser",
  })
  .then(() => {
    console.log("Build completed successfully!");
  })
  .catch((error) => {
    console.error("Esbuild Error:", error);
    process.exit(1);
  });
