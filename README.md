# Uzi

### Getting Started

1. Create DB by running `mix do ecto.create, ecto.migrate`
2. Start th server `mix run --no-halt`
3. Send request to `localhost:8081/send_requests` with payload
```
  {
    "url": "some url",
    "request_per_second_count": "20",
    "duration_sec": "2",
    "payload": {JSON}
  }
```