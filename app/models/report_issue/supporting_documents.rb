class ReportIssue::SupportingDocuments < ReportIssue
  CONTENT_TYPES_ALLOWED = %w[
    application/pdf
    image/jpeg
    image/png
    video/mp4
    video/quicktime
    video/x-ms-wmv
    application/msword
    application/vnd.ms-excel
    application/vnd.ms-powerpoint
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    application/vnd.openxmlformats-officedocument.presentationml.presentation
    message/rfc822
    application/octet-stream
  ].freeze

  FILE_SIZE_LIMIT = 10.megabytes
  MAXIMUM_FILE_UPLOADS = 5

  attr_accessor :documents, :continue

  def valid_document?(doc)
    @valid_document ||= !too_many_files? && valid_file_size?(doc) && valid_file_type?(doc) && non_empty_file?(doc) && octet_checks?(doc)
  end

  def info_only?
    true
  end

  def upload_step?
    true
  end

private

  def valid_file_size?(document)
    return true if document.size <= FILE_SIZE_LIMIT

    errors.add(
      :documents,
      I18n.t(
        "errors.upload.file_size_error_message",
        filename: document.original_filename,
        size_limit: ActiveSupport::NumberHelper.number_to_human_size(FILE_SIZE_LIMIT),
      ),
    )
    false
  end

  def non_empty_file?(document)
    return true unless document.size.zero?

    errors.add(
      :documents,
      I18n.t("errors.upload.empty_file_error_message"),
    )
    false
  end

  def too_many_files?
    return false unless supporting_docs.count >= MAXIMUM_FILE_UPLOADS

    errors.add(:documents, I18n.t("errors.upload.too_many_files_error_message", file_uploads: MAXIMUM_FILE_UPLOADS))
    true
  end

  def valid_file_type?(document)
    return true if CONTENT_TYPES_ALLOWED.include?(document.content_type)

    errors.add(:documents, I18n.t("errors.upload.file_type_error_message", filename: document.original_filename))
    false
  end

  def octet_checks?(document)
    # Only allow octet-stream if it's an msg file
    return true unless document.content_type == "application/octet-stream"
    return true if document.original_filename.downcase.ends_with?("msg")

    errors.add(:documents, I18n.t("errors.upload.file_type_error_message", filename: document.original_filename))
    false
  end
end
