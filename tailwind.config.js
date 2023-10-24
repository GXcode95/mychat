const twColors = require("tailwindcss/colors");

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
  theme: {
    extend: {
      colors: {
        // ...twColors,
        primary: "var(--color-primary)",
        white: "var(--color-white)",
        black: 'var(--color-black)',
        secondary: 'var(--color-secondary)',
        accent: 'var(--color-accent)',
        danger: 'var(--color-danger)',
        info: 'var(--color-info)',
        success: 'var(--color-success)',
      }
    }
  }
  // plugins: [
  //   require('daisyui')
  // ],
  // daisyui: {
  //   themes: ["light", "dark", "cupcake"],
  // }
};
