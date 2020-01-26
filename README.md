# Uzi

### Getting Started

1. Create DB by running `mix do ecto.create, ecto.migrate`
2. Start th server `mix run --no-halt`
3. Send request to `localhost:8081/send_requests` with payload
```
  {
    "url": "some url",
    "threads_count": "4",
    "requests_per_thread_count": "10",
    "timeout_between_requests_millisec": "3500",
    "payload": {JSON}
  }
```