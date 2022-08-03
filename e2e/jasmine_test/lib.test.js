import {sum} from "./lib.js";

describe("sum", () => {
    it("should sum 2+2", () => {
        expect(sum(2, 2)).toBe(4);
    });
})