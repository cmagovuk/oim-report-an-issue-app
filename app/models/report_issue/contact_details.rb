class ReportIssue::ContactDetails < ReportIssue
  EMAIL_REGEX = /\A(?!\.)("([^"\r\\]|\\["\r\\])*"|([-a-zA-Z0-9!#$%&'*+\/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)@[a-zA-Z0-9][\w.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z.]*[a-zA-Z]\z/.freeze
  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }

  with_options if: :email? do
    # validates :email, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
    # The above regex failed to pick up abc.def@mail.c as invalid
    validates :email, length: { maximum: 255 }, format: { with: EMAIL_REGEX }
  end

  with_options if: :telephone? do
    validates :telephone, length: { maximum: 30 }, format: { with: /\A(?:\+?|\b)[0-9 \-()]{5,}\b\z/ }
  end

  def permitted
    %w[first_name last_name email telephone].freeze
  end
end
