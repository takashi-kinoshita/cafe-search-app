import Rails from "@rails/ujs";
Rails.start();

import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import 'bootstrap/dist/css/bootstrap.min.css';
import "@hotwired/turbo";
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";
import 'script.js';

const application = Application.start();
const context = require.context("controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
