require 'fast_gettext'
require 'locale'

module HammerCLI
  module I18n

    module AllDomains
      def _(key)
        FastGettext::TranslationMultidomain.D_(key)
      end

      def n_(*keys)
        FastGettext::TranslationMultidomain.Dn_(*keys)
      end

      def s_(key, separator=nil)
        FastGettext::TranslationMultidomain.Ds_(key, separator)
      end

      def ns_(*keys)
        FastGettext::TranslationMultidomain.Dns_(*keys)
      end
    end


    class AbstractLocaleDomain

      def available_locales
        Dir.glob(locale_dir+'/*').select { |f| File.directory? f }.map { |f| File.basename(f) }
      end

      def translated_files
        []
      end

      def type
        :mo
      end

      def available?
        File.exist?(locale_dir)
      end

      attr_reader :locale_dir, :domain_name
    end


    class LocaleDomain < AbstractLocaleDomain

      def translated_files
        Dir.glob(File.join(File.dirname(__FILE__), '../**/*.rb'))
      end

      def locale_dir
        File.join(File.dirname(__FILE__), '../../locale')
      end

      def domain_name
        'hammer-cli'
      end

    end


    def self.locale
      lang_variant = Locale.current.to_simple.to_str
      lang = lang_variant.gsub(/_.*/, "")

      hammer_domain = HammerCLI::I18n::LocaleDomain.new
      if hammer_domain.available_locales.include? lang_variant
        lang_variant
      else
        lang
      end
    end


    def self.domains
      @domains ||= []
      @domains
    end


    def self.add_domain(domain)
      if domain.available?
        domains << domain
        FastGettext.add_text_domain(domain.domain_name, :path => domain.locale_dir, :type => domain.type, :report_warning => false)
      end
    end


    def self.clear
      FastGettext.translation_repositories.clear
      domains.clear
    end

    Encoding.default_external='UTF-8' if defined? Encoding
    FastGettext.locale = locale

  end
end

include FastGettext::Translation
include HammerCLI::I18n::AllDomains

HammerCLI::I18n.add_domain(HammerCLI::I18n::LocaleDomain.new)

