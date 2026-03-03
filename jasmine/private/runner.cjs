const path = require("path");

const shardCount = Number(process.env.TEST_TOTAL_SHARDS);
const shardIndex = Number(process.env.TEST_SHARD_INDEX);
const shardStatusFile = process.env.TEST_SHARD_STATUS_FILE;

/**
 * The prefix of the reason for skipping a spec due to sharding.
 */
const shardReasonPrefix = "Skipped: Assigned to shard";

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
  const fd = fs.openSync(shardStatusFile, "w");
  fs.closeSync(fd);

  // Safely override boot to intercept addReporter on the environment instance.
  // This is to exclude the skipped specs due to sharding from the test results.
  // Maintain the same behaviour between different versions of jasmine-core.
  const originalBoot = jasmine.boot;
  jasmine.boot = function () {
    const j$ = originalBoot.apply(this, arguments);
    const env = j$.getEnv();
    const originalAddReporter = env.addReporter;

    // Use Object.defineProperty to bypass the monkey-patching detection setter
    // which usually triggers the "Monkey patching detected" warning.
    Object.defineProperty(env, "addReporter", {
      value: function (reporter) {
        const wrappedReporter = new Proxy(reporter, {
          get(target, prop) {
            if (prop === "specDone") {
              return function (result) {
                if (
                  result.status === "pending" &&
                  result.pendingReason?.startsWith(shardReasonPrefix)
                ) {
                  // These specs are skipped due to sharding, so we don't want to report them as pending.
                  return;
                }

                return target.specDone?.apply(target, arguments);
              };
            }

            const value = target[prop];

            return typeof value === "function" ? value.bind(target) : value;
          },
        });

        return originalAddReporter.call(this, wrappedReporter);
      },
      configurable: true,
      writable: true,
      enumerable: true,
    });

    return j$;
  };

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
              `${shardReasonPrefix} ${assignedShard + 1} per strategy (Current: ${shardIndex + 1}).`,
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
