require 'translator/engine' if defined?(Rails) && Rails::VERSION::STRING.to_f >= 3.1

module Translator
  class << self
    attr_accessor :auth_handler, :current_store, :framework_keys
    attr_reader :simple_backend
    attr_writer :layout_name
  end

  @framework_keys = ["date.formats.default", "date.formats.short", "date.formats.long",
                     "time.formats.default", "time.formats.short", "time.formats.long", "time.am", "time.pm",
                     "support.array.words_connector", "support.array.two_words_connector", "support.array.last_word_connector",
                     "errors.format", "errors.messages.inclusion", "errors.messages.exclusion", "errors.messages.invalid",
                     "errors.messages.confirmation", "errors.messages.accepted", "errors.messages.empty",
                     "errors.messages.blank", "errors.messages.too_long", "errors.messages.too_short", "errors.messages.wrong_length",
                     "errors.messages.not_a_number", "errors.messages.not_an_integer", "errors.messages.greater_than",
                     "errors.messages.greater_than_or_equal_to", "errors.messages.equal_to", "errors.messages.less_than",
                     "errors.messages.less_than_or_equal_to", "errors.messages.odd", "errors.messages.even", "errors.required", "errors.blank",
                     "number.format.separator", "number.format.delimiter", "number.currency.format.format", "number.currency.format.unit",
                     "number.currency.format.separator", "number.currency.format.delimiter", "number.percentage.format.format", "number.percentage.format.delimiter",
                     "number.precision.format.delimiter", "number.human.format.delimiter", "number.human.storage_units.format",
                     "number.human.storage_units.units.byte.one", "number.human.storage_units.units.byte.other",
                     "number.human.storage_units.units.kb", "number.human.storage_units.units.mb", "number.human.storage_units.units.gb",
                     "number.human.storage_units.units.tb", "number.human.decimal_units.format", "number.human.decimal_units.units.unit",
                     "number.human.decimal_units.units.thousand", "number.human.decimal_units.units.million",
                     "number.human.decimal_units.units.billion", "number.human.decimal_units.units.trillion",
                     "number.human.decimal_units.units.quadrillion", "datetime.distance_in_words.half_a_minute",
                     "datetime.distance_in_words.less_than_x_seconds.one", "datetime.distance_in_words.less_than_x_seconds.other",
                     "datetime.distance_in_words.x_seconds.one", "datetime.distance_in_words.x_seconds.other",
                     "datetime.distance_in_words.less_than_x_minutes.one", "datetime.distance_in_words.less_than_x_minutes.other",
                     "datetime.distance_in_words.x_minutes.one", "datetime.distance_in_words.x_minutes.other",
                     "datetime.distance_in_words.about_x_hours.one", "datetime.distance_in_words.about_x_hours.other",
                     "datetime.distance_in_words.x_days.one", "datetime.distance_in_words.x_days.other",
                     "datetime.distance_in_words.about_x_months.one", "datetime.distance_in_words.about_x_months.other",
                     "datetime.distance_in_words.x_months.one", "datetime.distance_in_words.x_months.other",
                     "datetime.distance_in_words.about_x_years.one", "datetime.distance_in_words.about_x_years.other",
                     "datetime.distance_in_words.over_x_years.one", "datetime.distance_in_words.over_x_years.other",
                     "datetime.distance_in_words.almost_x_years.one", "datetime.distance_in_words.almost_x_years.other",
                     "datetime.prompts.year", "datetime.prompts.month", "datetime.prompts.day", "datetime.prompts.hour",
                     "datetime.prompts.minute", "datetime.prompts.second", "helpers.select.prompt", "helpers.submit.create",
                     "helpers.submit.update", "helpers.submit.submit", "pushr:configurations", "errors.messages.present",
                     "errors.messages.other_than", "errors.messages.already_confirmed", "errors.messages.confirmation_period_expired",
                     "errors.messages.expired", "errors.messages.not_found", "errors.messages.not_locked", "errors.messages.not_saved.one",
                     "errors.messages.not_saved.other", "helpers.page_entries_info.one_page.display_entries.zero",
                     "helpers.page_entries_info.one_page.display_entries.one", "helpers.page_entries_info.one_page.display_entries.other",
                     "helpers.page_entries_info.more_pages.display_entries", "mongoid.errors.messages.blank_in_locale",
                     "mongoid.errors.messages.ambiguous_relationship.message", "mongoid.errors.messages.ambiguous_relationship.summary",
                     "mongoid.errors.messages.ambiguous_relationship.resolution", "mongoid.errors.messages.callbacks.message",
                     "mongoid.errors.messages.callbacks.summary", "mongoid.errors.messages.callbacks.resolution",
                     "mongoid.errors.messages.calling_document_find_with_nil_is_invalid.message",
                     "mongoid.errors.messages.calling_document_find_with_nil_is_invalid.summary",
                     "mongoid.errors.messages.calling_document_find_with_nil_is_invalid.resolution",
                     "mongoid.errors.messages.document_not_destroyed.message", "mongoid.errors.messages.document_not_destroyed.summary",
                     "mongoid.errors.messages.document_not_destroyed.resolution", "mongoid.errors.messages.document_not_found.message",
                     "mongoid.errors.messages.document_not_found.summary", "mongoid.errors.messages.document_not_found.resolution",
                     "mongoid.errors.messages.document_with_attributes_not_found.message",
                     "mongoid.errors.messages.document_with_attributes_not_found.summary",
                     "mongoid.errors.messages.document_with_attributes_not_found.resolution",
                     "mongoid.errors.messages.eager_load.message", "mongoid.errors.messages.eager_load.summary",
                     "mongoid.errors.messages.eager_load.resolution", "mongoid.errors.messages.invalid_collection.message",
                     "mongoid.errors.messages.invalid_collection.summary", "mongoid.errors.messages.invalid_collection.resolution",
                     "mongoid.errors.messages.invalid_config_option.message", "mongoid.errors.messages.invalid_config_option.summary",
                     "mongoid.errors.messages.invalid_config_option.resolution", "mongoid.errors.messages.invalid_field.message",
                     "mongoid.errors.messages.invalid_field.summary", "mongoid.errors.messages.invalid_field.resolution",
                     "mongoid.errors.messages.invalid_field_option.message", "mongoid.errors.messages.invalid_field_option.summary",
                     "mongoid.errors.messages.invalid_field_option.resolution", "mongoid.errors.messages.invalid_includes.message",
                     "mongoid.errors.messages.invalid_includes.summary", "mongoid.errors.messages.invalid_includes.resolution",
                     "mongoid.errors.messages.invalid_index.message", "mongoid.errors.messages.invalid_index.summary",
                     "mongoid.errors.messages.invalid_index.resolution", "mongoid.errors.messages.invalid_options.message",
                     "mongoid.errors.messages.invalid_options.summary", "mongoid.errors.messages.invalid_options.resolution",
                     "mongoid.errors.messages.invalid_path.message", "mongoid.errors.messages.invalid_path.summary",
                     "mongoid.errors.messages.invalid_path.resolution", "mongoid.errors.messages.invalid_scope.message",
                     "mongoid.errors.messages.invalid_scope.summary", "mongoid.errors.messages.invalid_scope.resolution",
                     "mongoid.errors.messages.invalid_storage_options.message", "mongoid.errors.messages.invalid_storage_options.summary",
                     "mongoid.errors.messages.invalid_storage_options.resolution", "mongoid.errors.messages.invalid_storage_parent.message",
                     "mongoid.errors.messages.invalid_storage_parent.summary", "mongoid.errors.messages.invalid_storage_parent.resolution",
                     "mongoid.errors.messages.invalid_time.message", "mongoid.errors.messages.invalid_time.summary",
                     "mongoid.errors.messages.invalid_time.resolution", "mongoid.errors.messages.inverse_not_found.message",
                     "mongoid.errors.messages.inverse_not_found.summary", "mongoid.errors.messages.inverse_not_found.resolution",
                     "mongoid.errors.messages.invalid_set_polymorphic_relation.message",
                     "mongoid.errors.messages.invalid_set_polymorphic_relation.summary",
                     "mongoid.errors.messages.invalid_set_polymorphic_relation.resolution", "mongoid.errors.messages.invalid_value.message",
                     "mongoid.errors.messages.invalid_value.summary", "mongoid.errors.messages.invalid_value.resolution",
                     "mongoid.errors.messages.mixed_relations.message", "mongoid.errors.messages.mixed_relations.summary",
                     "mongoid.errors.messages.mixed_relations.resolution", "mongoid.errors.messages.mixed_session_configuration.message",
                     "mongoid.errors.messages.mixed_session_configuration.summary", "mongoid.errors.messages.mixed_session_configuration.resolution",
                     "mongoid.errors.messages.nested_attributes_metadata_not_found.message",
                     "mongoid.errors.messages.nested_attributes_metadata_not_found.summary",
                     "mongoid.errors.messages.nested_attributes_metadata_not_found.resolution", "mongoid.errors.messages.no_default_session.message",
                     "mongoid.errors.messages.no_default_session.summary", "mongoid.errors.messages.no_default_session.resolution",
                     "mongoid.errors.messages.no_environment.message", "mongoid.errors.messages.no_environment.summary",
                     "mongoid.errors.messages.no_environment.resolution", "mongoid.errors.messages.no_map_reduce_output.message",
                     "mongoid.errors.messages.no_map_reduce_output.summary", "mongoid.errors.messages.no_map_reduce_output.resolution",
                     "mongoid.errors.messages.no_metadata.message", "mongoid.errors.messages.no_metadata.summary",
                     "mongoid.errors.messages.no_metadata.resolution", "mongoid.errors.messages.no_parent.message",
                     "mongoid.errors.messages.no_parent.summary", "mongoid.errors.messages.no_parent.resolution",
                     "mongoid.errors.messages.no_session_config.message", "mongoid.errors.messages.no_session_config.summary",
                     "mongoid.errors.messages.no_session_config.resolution", "mongoid.errors.messages.no_sessions_config.message",
                     "mongoid.errors.messages.no_sessions_config.summary", "mongoid.errors.messages.no_sessions_config.resolution",
                     "mongoid.errors.messages.no_session_database.message", "mongoid.errors.messages.no_session_database.summary",
                     "mongoid.errors.messages.no_session_database.resolution", "mongoid.errors.messages.no_session_hosts.message",
                     "mongoid.errors.messages.no_session_hosts.summary", "mongoid.errors.messages.no_session_hosts.resolution",
                     "mongoid.errors.messages.readonly_attribute.message", "mongoid.errors.messages.readonly_attribute.summary",
                     "mongoid.errors.messages.readonly_attribute.resolution", "mongoid.errors.messages.readonly_document.message",
                     "mongoid.errors.messages.readonly_document.summary", "mongoid.errors.messages.readonly_document.resolution",
                     "mongoid.errors.messages.scope_overwrite.message", "mongoid.errors.messages.scope_overwrite.summary",
                     "mongoid.errors.messages.scope_overwrite.resolution", "mongoid.errors.messages.taken",
                     "mongoid.errors.messages.too_many_nested_attribute_records.message",
                     "mongoid.errors.messages.too_many_nested_attribute_records.summary",
                     "mongoid.errors.messages.too_many_nested_attribute_records.resolution", "mongoid.errors.messages.unknown_attribute.message",
                     "mongoid.errors.messages.unknown_attribute.summary", "mongoid.errors.messages.unknown_attribute.resolution",
                     "mongoid.errors.messages.unsaved_document.message", "mongoid.errors.messages.unsaved_document.summary",
                     "mongoid.errors.messages.unsaved_document.resolution", "mongoid.errors.messages.unsupported_javascript.message",
                     "mongoid.errors.messages.unsupported_javascript.summary", "mongoid.errors.messages.unsupported_javascript.resolution",
                     "mongoid.errors.messages.validations.message", "mongoid.errors.messages.validations.summary",
                     "mongoid.errors.messages.validations.resolution", "mongoid.errors.messages.delete_restriction.message",
                     "mongoid.errors.messages.delete_restriction.summary", "mongoid.errors.messages.delete_restriction.resolution",
                     "mongoid.errors.models.application.attributes.redirect_uri.fragment_present",
                     "mongoid.errors.models.application.attributes.redirect_uri.invalid_uri",
                     "mongoid.errors.models.application.attributes.redirect_uri.relative_uri", "zodiac.aries", "zodiac.taurus",
                     "zodiac.gemini", "zodiac.cancer", "zodiac.leo", "zodiac.virgo", "zodiac.libra", "zodiac.scorpio",
                     "zodiac.sagittarius", "zodiac.capricorn", "zodiac.aquarius", "zodiac.pisces", "grape.errors.format",
                     "grape.errors.messages.coerce", "grape.errors.messages.presence", "grape.errors.messages.regexp",
                     "grape.errors.messages.values", "grape.errors.messages.missing_vendor_option.problem",
                     "grape.errors.messages.missing_vendor_option.summary", "grape.errors.messages.missing_vendor_option.resolution",
                     "grape.errors.messages.missing_mime_type.problem", "grape.errors.messages.missing_mime_type.resolution",
                     "grape.errors.messages.invalid_with_option_for_represent.problem",
                     "grape.errors.messages.invalid_with_option_for_represent.resolution", "grape.errors.messages.missing_option",
                     "grape.errors.messages.invalid_formatter", "grape.errors.messages.invalid_versioner_option.problem",
                     "grape.errors.messages.invalid_versioner_option.resolution", "grape.errors.messages.unknown_validator",
                     "grape.errors.messages.unknown_options", "grape.errors.messages.incompatible_option_values",
                     "grape.errors.messages.mutual_exclusion", "grape.errors.messages.at_least_one", "grape.errors.messages.exactly_one",
                     "flash.actions.create.notice", "flash.actions.update.notice", "flash.actions.destroy.notice",
                     "flash.actions.destroy.alert", "will_paginate.previous_label", "will_paginate.next_label", "will_paginate.page_gap",
                     "will_paginate.page_entries_info.single_page.zero", "will_paginate.page_entries_info.single_page.one",
                     "will_paginate.page_entries_info.single_page.other", "will_paginate.page_entries_info.single_page_html.zero",
                     "will_paginate.page_entries_info.single_page_html.one", "will_paginate.page_entries_info.single_page_html.other",
                     "will_paginate.page_entries_info.multi_page", "will_paginate.page_entries_info.multi_page_html",
                     "activerecord.errors.models.application.attributes.redirect_uri.fragment_present",
                     "activerecord.errors.models.application.attributes.redirect_uri.invalid_uri",
                     "activerecord.errors.models.application.attributes.redirect_uri.relative_uri",
                     "mongo_mapper.errors.models.application.attributes.redirect_uri.fragment_present",
                     "mongo_mapper.errors.models.application.attributes.redirect_uri.invalid_uri",
                     "mongo_mapper.errors.models.application.attributes.redirect_uri.relative_uri",
                     "doorkeeper.errors.messages.invalid_request",
                     "doorkeeper.errors.messages.invalid_redirect_uri", "doorkeeper.errors.messages.unauthorized_client",
                     "doorkeeper.errors.messages.access_denied", "doorkeeper.errors.messages.invalid_scope",
                     "doorkeeper.errors.messages.server_error", "doorkeeper.errors.messages.temporarily_unavailable",
                     "doorkeeper.errors.messages.credential_flow_not_configured",
                     "doorkeeper.errors.messages.resource_owner_authenticator_not_configured",
                     "doorkeeper.errors.messages.unsupported_response_type", "doorkeeper.errors.messages.invalid_client",
                     "doorkeeper.errors.messages.invalid_grant", "doorkeeper.errors.messages.unsupported_grant_type",
                     "doorkeeper.errors.messages.invalid_resource_owner", "doorkeeper.errors.messages.invalid_token.revoked",
                     "doorkeeper.errors.messages.invalid_token.expired", "doorkeeper.errors.messages.invalid_token.unknown",
                     "doorkeeper.flash.applications.create.notice", "doorkeeper.flash.applications.destroy.notice",
                     "doorkeeper.flash.applications.update.notice", "doorkeeper.flash.authorized_applications.destroy.notice",
                     "devise.confirmations.confirmed", "devise.confirmations.send_instructions", "devise.confirmations.send_paranoid_instructions",
                     "devise.failure.already_authenticated", "devise.failure.inactive", "devise.failure.invalid", "devise.failure.locked",
                     "devise.failure.last_attempt", "devise.failure.not_found_in_database", "devise.failure.timeout",
                     "devise.failure.unauthenticated", "devise.failure.unconfirmed", "devise.mailer.confirmation_instructions.subject",
                     "devise.mailer.reset_password_instructions.subject", "devise.mailer.unlock_instructions.subject",
                     "devise.omniauth_callbacks.failure", "devise.omniauth_callbacks.success", "devise.passwords.no_token",
                     "devise.passwords.send_instructions", "devise.passwords.send_paranoid_instructions", "devise.passwords.updated",
                     "devise.passwords.updated_not_active", "devise.registrations.destroyed", "devise.registrations.signed_up",
                     "devise.registrations.signed_up_but_inactive", "devise.registrations.signed_up_but_locked",
                     "devise.registrations.signed_up_but_unconfirmed", "devise.registrations.update_needs_confirmation",
                     "devise.registrations.updated", "devise.sessions.signed_in", "devise.sessions.signed_out",
                     "devise.sessions.already_signed_out", "devise.unlocks.send_instructions", "devise.unlocks.send_paranoid_instructions",
                     "devise.unlocks.unlocked", "views.pagination.first", "views.pagination.last", "views.pagination.previous",
                     "views.pagination.next", "views.pagination.truncate"]

  def self.setup_backend(simple_backend)
    @simple_backend = simple_backend

    I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(@current_store), @simple_backend)
  end

  def self.locales
    I18n.available_locales
  end

  def self.keys_for_strings(options = {})
    @simple_backend.available_locales

    flat_translations = {}
    flatten_keys nil, @simple_backend.instance_variable_get("@translations")[:en], flat_translations
    flat_translations = flat_translations.delete_if {|k,v| !v.is_a?(String) }
    store_keys = Translator.current_store.keys.map {|k| k.sub(/^[a-z0-9\-_]*\./i, '')}

    keys = if options[:group].to_s == "deleted"
      store_keys - flat_translations.keys
    else
      store_keys + flat_translations.keys
    end.uniq

    if options[:filter]
      keys = keys.select {|k| k[0, options[:filter].size] == options[:filter]}
    end

    case options[:group].to_s
    when "framework"
      keys.select! {|k| @framework_keys.include?(k) }
    when "application"
      keys -= @framework_keys
    end

    keys || []
  end

  def self.layout_name
    @layout_name || "translator"
  end

  def self.translations(options = {})
    I18n.locale = options[:locale] || I18n.default_locale
    group = options[:group] || "application"

    keys = Translator.keys_for_strings(group: group)

    # calculate translations
    Hash[keys.map { |key|
      [
        key,
        begin I18n.t key; rescue; end
      ]
    }]
  end

  private

  def self.flatten_keys(current_key, hash, dest_hash)
    hash.each do |key, value|
      full_key = [current_key, key].compact.join('.')
      if value.kind_of?(Hash)
        flatten_keys full_key, value, dest_hash
      else
        dest_hash[full_key] = value
      end
    end
    hash
  end
end

