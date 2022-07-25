# == Class: glance::wsgi
#
# Configure wsgi options
#
# === Parameters
#
# [*task_pool_threads*]
#   (Optional) The number of thredas (per worker process) in the pool for
#   processing asynchronous tasks.
#   Defaults to $::os_service_default
#
# [*python_interpreter*]
#   (Optional) Path to the python interpreter to use when spawning external
#   processes.
#   Defaults to $::os_service_default
#
class glance::wsgi (
  $task_pool_threads  = $::os_service_default,
  $python_interpreter = $::os_service_default,
) {

  include glance::deps

  glance_api_config {
    'wsgi/task_pool_threads':  value => $task_pool_threads;
    'wsgi/python_interpreter': value => $python_interpreter;
  }
}
