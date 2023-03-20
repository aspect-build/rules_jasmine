const reporters = require("jasmine-reporters");
const path = require("path");

const xmlOutputFile = process.env.XML_OUTPUT_FILE;

jasmine.getEnv().addReporter(
  new reporters.JUnitXmlReporter({
    filePrefix: path.basename(xmlOutputFile),
    savePath: path.dirname(xmlOutputFile),
    consolidate: true,
    consolidateAll: true,
  })
);
