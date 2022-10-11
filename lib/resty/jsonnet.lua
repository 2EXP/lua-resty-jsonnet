local ffi = require "ffi"

local _M = { _VERSION = '0.01' }
local mt = { __index = _M  }

local jsonnet = ffi.load("libjsonnet")

ffi.cdef[[
  const char *jsonnet_version(void);
  struct JsonnetVm *jsonnet_make(void);
  void jsonnet_max_stack(struct JsonnetVm *vm, unsigned v);
  void jsonnet_gc_min_objects(struct JsonnetVm *vm, unsigned v);
  void jsonnet_gc_growth_trigger(struct JsonnetVm *vm, double v);
  void jsonnet_string_output(struct JsonnetVm *vm, int v);

  const char *jsonnet_json_extract_string(struct JsonnetVm *vm,
                                          const struct JsonnetJsonValue *v);
  int jsonnet_json_extract_number(struct JsonnetVm *vm,
                                  const struct JsonnetJsonValue *v, double *out);
  int jsonnet_json_extract_bool(struct JsonnetVm *vm,
                                const struct JsonnetJsonValue *v);
  int jsonnet_json_extract_null(struct JsonnetVm *vm,
                                const struct JsonnetJsonValue *v);
  struct JsonnetJsonValue *jsonnet_json_make_string(struct JsonnetVm *vm,
                                                    const char *v);
  struct JsonnetJsonValue *jsonnet_json_make_number(struct JsonnetVm *vm,
                                                    double v);
  struct JsonnetJsonValue *jsonnet_json_make_bool(struct JsonnetVm *vm, int v);
  struct JsonnetJsonValue *jsonnet_json_make_null(struct JsonnetVm *vm);
  struct JsonnetJsonValue *jsonnet_json_make_array(struct JsonnetVm *vm);
  void jsonnet_json_array_append(struct JsonnetVm *vm,
                                 struct JsonnetJsonValue *arr,
                                 struct JsonnetJsonValue *v);
  struct JsonnetJsonValue *jsonnet_json_make_object(struct JsonnetVm *vm);
  void jsonnet_json_object_append(struct JsonnetVm *vm,
                                  struct JsonnetJsonValue *obj, const char *f,
                                  struct JsonnetJsonValue *v);

  char *jsonnet_realloc(struct JsonnetVm *vm, char *buf, size_t sz);
  void jsonnet_json_destroy(struct JsonnetVm *vm, struct JsonnetJsonValue *v);

  typedef char *JsonnetImportCallback(void *ctx, const char *base,
                                      const char *rel, char **found_here,
                                      int *success);
  typedef struct JsonnetJsonValue *
  JsonnetNativeCallback(void *ctx, const struct JsonnetJsonValue *const *argv,
                        int *success);
  void jsonnet_import_callback(struct JsonnetVm *vm, JsonnetImportCallback *cb,
                               void *ctx);
  void jsonnet_native_callback(struct JsonnetVm *vm, const char *name,
                               JsonnetNativeCallback *cb, void *ctx,
                               const char *const *params);

  void jsonnet_ext_var(struct JsonnetVm *vm, const char *key, const char *val);
  void jsonnet_ext_code(struct JsonnetVm *vm, const char *key, const char *val);
  void jsonnet_tla_var(struct JsonnetVm *vm, const char *key, const char *val);
  void jsonnet_tla_code(struct JsonnetVm *vm, const char *key, const char *val);

  void jsonnet_max_trace(struct JsonnetVm *vm, unsigned v);
  void jsonnet_jpath_add(struct JsonnetVm *vm, const char *v);

  char *jsonnet_evaluate_file(struct JsonnetVm *vm, const char *filename,
                              int *error);
  char *jsonnet_evaluate_snippet(struct JsonnetVm *vm, const char *filename,
                                 const char *snippet, int *error);
  char *jsonnet_evaluate_file_multi(struct JsonnetVm *vm, const char *filename,
                                    int *error);
  char *jsonnet_evaluate_snippet_multi(struct JsonnetVm *vm, const char *filename,
                                       const char *snippet, int *error);
  char *jsonnet_evaluate_file_stream(struct JsonnetVm *vm, const char *filename,
                                     int *error);
  char *jsonnet_evaluate_snippet_stream(struct JsonnetVm *vm,
                                        const char *filename, const char *snippet,
                                        int *error);
  void jsonnet_destroy(struct JsonnetVm *vm);
]]

local error_type = ffi.typeof("int[?]")

local _vm

local function _return(out, error)
  local out_data = ffi.string(out)
  jsonnet.jsonnet_realloc(_vm, out, 0)

  if error[0] == 0 then
    return out_data
  else
    return nil, out_data
  end
end

function _M.init()
  _vm = jsonnet.jsonnet_make()
  return setmetatable({}, mt)
end

function _M.version()
  local version = jsonnet.jsonnet_version()
  return ffi.string(version)
end

function _M.max_stack(v)
  jsonnet.jsonnet_max_stack(_vm, v)
end

function _M.gc_min_objects(v)
  jsonnet.jsonnet_gc_min_objects(_vm, v)
end

function _M.gc_growth_trigger(v)
  jsonnet.jsonnet_gc_growth_trigger(_vm, v)
end

function _M.string_output(v)
  jsonnet.jsonnet_string_output(_vm, v)
end

function _M.import_callback(cb, ctx)
  jsonnet.jsonnet_import_callback(_vm, cb, ctx)
end

function _M.ext_var(key, val)
  jsonnet.jsonnet_ext_var(_vm, key, val)
end
  
function _M.ext_code(key, val)
  jsonnet.jsonnet_ext_code(_vm, key, val)
end

function _M.tla_var(key, val)
  jsonnet.jsonnet_tla_var(_vm, key, val)
end

function _M.tla_code(key, val)
  jsonnet.jsonnet_tla_code(_vm, key, val)
end

function _M.max_trace(v)
  jsonnet.jsonnet_max_trace(_vm, v)
end

function _M.jpath_add(v)
  jsonnet.jsonnet_jpath_add(_vm, v)
end

function _M.evaluate_file(json_file)
  local error = ffi.new(error_type, 1)
  local out = jsonnet.jsonnet_evaluate_file(_vm, json_file, error)

  return _return(out, error)
end

function _M.evaluate_snippet(json_file, json_snippet)
  local error = ffi.new(error_type, 1)
  local out = jsonnet.jsonnet_evaluate_snippet(_vm, json_file, json_snippet, error)

  return _return(out, error)
end

function _M.evaluate_file_multi(json_file)
  local error = ffi.new(error_type, 1)
  local out = jsonnet.jsonnet_evaluate_file_multi(_vm, json_file, error)

  return _return(out, error)
end

function _M.evaluate_snippet_multi(json_file, json_snippet)
  local error = ffi.new(error_type, 1)
  local out = jsonnet.jsonnet_evaluate_snippet_multi(_vm, json_file, json_snippet, error)

  return _return(out, error)
end
  
function _M.evaluate_file_stream(json_file)
  local error = ffi.new(error_type, 1)
  local out = jsonnet.jsonnet_evaluate_file_stream(_vm, json_file, error)

  return _return(out, error)
end

function _M.evaluate_snippet_stream(json_file, json_snippet)
  local error = ffi.new(error_type, 1)
  local out = jsonnet.jsonnet_evaluate_snippet_stream(_vm, json_file, json_snippet, error)

  return _return(out, error)
end

function _M.destroy()
  jsonnet.jsonnet_destroy(_vm)
end

return _M
