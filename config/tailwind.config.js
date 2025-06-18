// config/tailwind.config.js
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.scss",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      width: {
        70: "280px",
      },
    },
  },
};
