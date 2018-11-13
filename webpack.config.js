'use strict';

const {resolve} = require('path');
let MODE =
  process.env.NODE_ENV === 'production' ? 'production' : 'development';

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: resolve(__dirname, 'dist')
  },
  mode: MODE,
  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            optimize: MODE === 'production',
            debug: MODE === 'development'
          }
        }
      }
    ],
    noParse: /\.elm$/
  }
};
