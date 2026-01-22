json.extract! booking, :id, :user_id, :gym_id, :start_time, :end_time, :status, :note, :created_at, :updated_at
json.url booking_url(booking, format: :json)
