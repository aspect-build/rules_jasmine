describe('filtering', () => {
    describe('exclusions', () => {
      xit('should not run this one', () => {
        fail('Ran an excluded (xit) test');
      });

      it('should run this one', () => {
        expect(true).toBeTruthy();
      });
    });

    xdescribe('focusing', () => {
      it('should not run this one', () => {
        fail('Ran an excluded (xdescribe) test');
      });
    });
});