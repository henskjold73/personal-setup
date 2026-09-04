module.exports = {
  config: {
    fontSize: 14,
    fontFamily: '"JetBrainsMono Nerd Font", "JetBrains Mono", Menlo, monospace',
    cursorShape: "BEAM",
    cursorBlink: true,

    // Tokyo Night palette
    foregroundColor: "#c0caf5",
    backgroundColor: "#1a1b26",
    borderColor: "#1a1b26",
    cursorColor: "#c0caf5",

    colors: {
      black: "#15161e",
      red: "#f7768e",
      green: "#9ece6a",
      yellow: "#e0af68",
      blue: "#7aa2f7",
      magenta: "#bb9af7",
      cyan: "#7dcfff",
      white: "#a9b1d6",
      lightBlack: "#414868",
      lightRed: "#f7768e",
      lightGreen: "#9ece6a",
      lightYellow: "#e0af68",
      lightBlue: "#7aa2f7",
      lightMagenta: "#bb9af7",
      lightCyan: "#7dcfff",
      lightWhite: "#c0caf5",
    },

    shell: "/bin/zsh",
    shellArgs: ["--login"],

    copyOnSelect: true,
    quickEdit: true,
  },

  plugins: ["hyper-tab-icons"],
  localPlugins: [],
  keymaps: {},
};
