# Uzi

### Getting Started

1. Create DB by running `mix do ecto.create, ecto.migrate`
2. Start th server `mix run --no-halt`
3. Send request to `localhost:8081/send_requests` with payload
```
  {
    "url": "some url",
    "requests_count": "20",
    "iterations_count": "2",
    "timeout_millisec": "15",
    "payload": {JSON}
  }
```