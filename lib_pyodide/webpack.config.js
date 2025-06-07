const { PyodidePlugin } = require("@pyodide/webpack-plugin");
const HtmlWebpackPlugin = require('html-webpack-plugin');

const path = require('path');


module.exports = {
  mode: 'development',
  entry: './src/flyodide.ts',
  plugins: [new PyodidePlugin(), new HtmlWebpackPlugin({
    template: './src/flyodide.html',
    filename: 'flyodide.html',
  }),],
  module: {
    rules: [
      {
        test: /\.ts$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: [
              '@babel/preset-env',
              '@babel/preset-typescript',
            ],
          },
        },
      },
    ],
  },
  output: {
    path: path.resolve(__dirname, '../lib/core/'),
    filename: 'flyodide.js',
  },
  devServer: {
    static: '../lib/core/',
    hot: true
  }

};