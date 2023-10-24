module.exports = ({ env }) => ({
  plugins: [
    require("postcss-easy-import")({
      prefix: "_",
      extensions: [".css"],
    }),
    require("tailwindcss/nesting"),
    require("tailwindcss"),
    require("autoprefixer"),
    require("cssnano")(env === "production" ? { preset: "default" } : false),
  ],
});
