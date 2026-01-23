module BookingsHelper
  def booking_status_badge(status)
    case status
    when "pending"
      content_tag(:span, "申請中", style: "color: #d97706; font-weight: bold;")
    when "approved"
      content_tag(:span, "承認", style: "color: #16a34a; font-weight: bold;")
    when "rejected"
      content_tag(:span, "却下", style: "color: #dc2626; font-weight: bold;")
    when "canceled"
      content_tag(:span, "キャンセル", style: "color: #6b7280; font-weight: bold;")
    else
      status
    end
  end
end
