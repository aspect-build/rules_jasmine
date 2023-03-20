const path = require("path");

const shardCount = Number(process.env.TEST_TOTAL_SHARDS);
const shardIndex = Number(process.env.TEST_SHARD_INDEX);
const shardStatusFile = process.env.TEST_SHARD_STATUS_FILE;

if (shardCount) {
  const jasmine = require("jasmine-core");
  const fs = require("fs");

  // Sharding protocol:
  // Tell Bazel that this test runner supports sharding by updating the last modified date of the
  // magic file
  let fd = fs.openSync(shardStatusFile, "w");
  fs.closeSync(fd);

  let getTotalSpecsDefined;

  const SuiteBuilder = jasmine.SuiteBuilder;
  jasmine.SuiteBuilder = ($j) => {
    return class ProxySuiteBuilder extends SuiteBuilder($j) {
      constructor(options) {
        super(options);
        getTotalSpecsDefined = () => this.totalSpecsDefined;
      }
    };
  };

  const Order = jasmine.Order;
  jasmine.Order = ($j) => {
    const DefaultOrder = Order($j);
    return class ShardingOrder {
      constructor(options) {
        this.default = new DefaultOrder(options);
      }
      sort(items) {
        const totalSpecsDefined = getTotalSpecsDefined();
        const minIndex = (totalSpecsDefined * shardIndex) / shardCount;
        const maxIndex = (totalSpecsDefined * (shardIndex + 1)) / shardCount;

        const filtered = [];
        for (const item of items) {
          // See: https://github.com/jasmine/jasmine/blob/d0a9931ae6bfa63c73952a07b1cff05b2a8b38e8/src/core/SuiteBuilder.js#L170
          if (item.id.startsWith("suite")) {
            filtered.push(item);
            continue;
          }
          // See: https://github.com/jasmine/jasmine/blob/d0a9931ae6bfa63c73952a07b1cff05b2a8b38e8/src/core/SuiteBuilder.js#L201
          const index = Number(item.id.replace("spec", ""));
          if (index >= minIndex && index < maxIndex) {
            filtered.push(item);
          }
        }

        return this.default.sort(filtered);
      }
    };
  };
}

const jasmine_path = require.resolve("jasmine");
const jasmine_bin_path = path.join(
  jasmine_path,
  "..",
  "..",
  "bin",
  "jasmine.js"
);
require(jasmine_bin_path);
