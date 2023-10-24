module.exports = {
  content: [
    `${process.env.SIMPLE_FORM_TAILWIND_DIR}/**/*.rb`,
    "./app/views/**/*.html.erb",
    "./app/views/**/*.slim",
    "./config/initializers/simple_form.rb",
    "./app/components/**/*.(rb|slim)",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    './config/initializers/heroicon.rb',
  ],
  // plugins: [
  //   require('daisyui')
  // ],
  // daisyui: {
  //   themes: ["light", "dark", "cupcake"],
  // }
};
