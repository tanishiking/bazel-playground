module.exports = function override(config, env) {
  config.node = { global: false }
  return config;
}
