require 'pathname'
require 'yaml'

# yamlからロードしたHashの値をメソッドでも取得できるようにする
# e.g.) CONF['db'] === CONF.db
CONF = YAML.load_file(Pathname.new(__dir__).join('../../conf.yml'))
hash_method_define = proc do |obj|
  obj.each do |k, v|
    if v.is_a?(Hash)
      child = obj[k]
      hash_method_define.call(child)
      obj.define_singleton_method(k) { child }
    else
      obj.define_singleton_method(k) { v }
    end
  end
end
hash_method_define.call(CONF)
CONF.freeze
