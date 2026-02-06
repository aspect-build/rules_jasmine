describe('assert sharding runs specs(it blocks) in the expected order and partitions equally over the available shards', () => {
    let testIsolationFailure = 0;

    it('should run the first spec first in shard 1', () => {
      testIsolationFailure = 1;
      expect(true).toBe(true);
    });

    it('should run the second spec in the same shard with the first in shard 2', () => {
      expect(testIsolationFailure).toBe(0);
      testIsolationFailure = 2;
    });

    it('should run the third spec in a separate shard in shard 3', () => {
      expect(testIsolationFailure).toBe(0);
      testIsolationFailure = 3;
    });

    it('should run the fourth spec in the same shard with the first in shard 1', () => {
      expect(testIsolationFailure).toBe(1);
    });
    
    it('should run the fifth spec in shard 2', () => {
      expect(testIsolationFailure).toBe(2);
    });

    it('should run the sixth spec with the third spec in shard 3', () => {
      expect(testIsolationFailure).toBe(3);
    });
});