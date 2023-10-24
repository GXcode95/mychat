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
        primary: "#3b82f6", // blue-500
        // 'white': '#ffffff',
        // 'black': '#0a0a0a',
        secondary: '#6366f1', // indigo-500
        accent: '#eab308', // yellow-500
        danger: '#ef4444', // red-500
        info: '#06b6d4', // cyan-500
        success: '#22c55e', // green-500
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
