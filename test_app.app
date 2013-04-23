{application, test_app,
 [{description, "test_app"},
  {vsn, "1"},
  {modules, [impl]},
  {registered, [impl]},
  {applications, [kernel, stdlib]},
  {mod, {test_app,[]}}
 ]}.