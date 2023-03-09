const { say_hi } = require("./lib.js");

describe("lib", () => {
    it("should say hi", () => {
        expect(say_hi()).toBe("hi");
    });
});
