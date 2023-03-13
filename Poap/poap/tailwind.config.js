/** @type {import('tailwindcss').Config} */
module.exports = {
  plugins: [require("daisyui")],
  daisyui: {
    styled: true,
    themes: true,
    base: true,
    utils: true,
    logs: true,
    rtl: false,
    prefix: "",
    darkTheme: "black",
  },
  content: ["./pages/**/*.tsx", "./components/**/*.tsx"],
  theme: {
    extend: {},
  },
};
