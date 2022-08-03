import { say_hi } from "./lib.js"

describe("lib", () => {
    it("should say hi", () => {
        expect(say_hi()).toBe("hi");
    })  
})