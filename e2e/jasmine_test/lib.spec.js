import {sum} from "./lib.js";

describe("sum", () => {
    it("should sum 1+1", () => {
        expect(sum(1, 1)).toBe(2);
    });
})