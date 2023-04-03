describe('focusing', () => {
  fit('should run this one', () => {
    expect(true).toBeTruthy();
  });
  it('should not run this one', () => {
    fail('ran a test that was not focused');
  });
});