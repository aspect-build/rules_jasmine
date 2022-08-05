const fs = require("fs");
const assert = require("assert");

jasmine.getEnv().addReporter({
    jasmineDone: () => {
        try {
            const reportContent = fs.readFileSync(process.env.XML_OUTPUT_FILE).toString()
            assert.ok(reportContent.includes(`testsuite name="JUnit reporter"`));
            assert.ok(reportContent.includes(`errors="0" tests="1" skipped="0" disabled="0" failures="0"`));
            assert.ok(reportContent.includes(`testcase classname="JUnit reporter" name="this should be reported"`));
        } catch(e) {
            console.error(e);
            process.exit(1);
        }
    }
});

describe("JUnit reporter", () => {
    it("this should be reported", () => {
        expect(1).toBe(1);
    });
});