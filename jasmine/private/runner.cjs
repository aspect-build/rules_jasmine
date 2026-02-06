const path = require("path");

const shardCount = Number(process.env.TEST_TOTAL_SHARDS);
const shardIndex = Number(process.env.TEST_SHARD_INDEX);
const shardStatusFile = process.env.TEST_SHARD_STATUS_FILE;

if (shardCount) {
  const fs = require("node:fs");
  const jasmine = require("jasmine-core");

  const [major, minor, patch] = jasmine.version().split(".", 3).map(Number);
  // Versions of jasmine-core prior to 6.0.1 require filtering items before sorting for sharding; otherwise,
  // the shard incorrectly includes all items. In version 6.0.1 and later, the sorting process must not remove items,
  // as doing so triggers a `Cannot read properties of undefined (reading 'willExecute')` error. We now handle this by specifically
  // excluding unused specs from the shard instead.
  const shouldUseFilteredItems =
    major < 6 || (major === 6 && minor === 0 && patch === 0);

  // Sharding protocol:
  // Tell Bazel that this test runner supports sharding by updating the last modified date of the
  // magic file
  let fd = fs.openSync(shardStatusFile, "w");
  fs.closeSync(fd);

  const Order = jasmine.Order;
  jasmine.Order = ($j) => {
    const DefaultOrder = Order($j);
    return class ShardingOrder {
      constructor(options) {
        this.default = new DefaultOrder(options);
      }
      sort(items) {
        const filterItems = [];
        for (const item of items) {
          // See: https://github.com/jasmine/jasmine/blob/d0a9931ae6bfa63c73952a07b1cff05b2a8b38e8/src/core/SuiteBuilder.js#L170
          if (item.id.startsWith("suite")) {
            filterItems.push(item);
            continue;
          }

          // See: https://github.com/jasmine/jasmine/blob/d0a9931ae6bfa63c73952a07b1cff05b2a8b38e8/src/core/SuiteBuilder.js#L201
          const index = Number(item.id.replace("spec", ""));
          const assignedShard = index % shardCount;
          if (assignedShard !== shardIndex) {
            // Bazel shards are not 0 indexed, so we add 1 to the shard index.
            item.exclude(
              `Skipped: Assigned to shard ${assignedShard + 1} per strategy (Current: ${shardIndex + 1}).`,
            );
          } else {
            filterItems.push(item);
          }
        }

        return this.default.sort(shouldUseFilteredItems ? filterItems : items);
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
  "jasmine.js",
);
require(jasmine_bin_path);
