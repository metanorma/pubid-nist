module Pubid::Nist
  class Renderer < Pubid::Core::Renderer::Base
    def render_base_identifier(**opts)
      prerender(**opts)

      render_identifier(@prerendered_params, opts)
    end

    def render_identifier(params, opts)
      result = "%{serie}%{stage}%{code}%{volume}%{part}%{edition}%{revision}%{version}"\
      "%{supplement}%{section}%{appendix}%{errata}%{index}%{insert}%{update}"\
      "%{translation}" % params

      if params[:addendum] && !params[:addendum].empty?
        case opts[:format]
        when :long
          "Addendum to #{result}"
        when :abbrev
          "Add. to #{result}"
        when :short
          "#{result} Add."
        when :mr
          "#{result}.add-1"
        end
      else
        result
      end
    end

    def render_serie(serie, opts, params)
      if serie.to_s(opts[:format]).include?(params[:publisher].to_s(opts[:format]))
        return serie.to_s(opts[:format])
      end

      "#{params[:publisher].to_s(opts[:format])} #{serie.to_s(opts[:format])}"
    end

    def render_code(code, opts, _params)
      (opts[:format] == :mr ? "." : " ") + code.to_s
    end

    def render_edition(edition, opts, _params)
      case opts[:format]
      when :long
        " Edition "
      when :abbrev
        " Ed. "
      when :short, :mr
        "e"
      end + edition.to_s
    end

    def render_revision(revision, opts, _params)
      case opts[:format]
      when :long
        ", Revision "
      when :abbrev
        ", Rev. "
      when :short, :mr
        "r"
      end + (revision == '' ? '1' : revision).to_s
    end

    def render_version(version, opts, _params)
      case opts[:format]
      when :long
        ", Version "
      when :abbrev
        ", Ver. "
      when :short, :mr
        "ver"
      end + version
    end

    def render_volume(volume, opts, params)
      case opts[:format]
      when :long
        ", Volume "
      when :abbrev
        ", Vol. "
      when :short
        params[:code] ? "v" : " v"
      when :mr
        params[:code] ? "v" : ".v"
      end + volume
    end

    def render_update(update, opts, _params)
      update_text = update.number.to_s
      update_text += "-#{update.year}" if update.year
      update_text += sprintf("%02d", update.month) if update.month

      case opts[:format]
      when :long
        " Update #{update_text}"
      when :abbrev
        " Upd. #{update_text}"
      when :short
        "/Upd#{update_text}"
      when :mr
        ".u#{update_text}"
      end
    end

    def render_translation(translation, opts, _params)
      case opts[:format]
      when :long, :abbrev
        " (#{translation.upcase})"
      when :mr
        ".#{translation}"
      when :short
        "(#{translation})"
      end
    end

    def render_part(part, opts, _params)
      case opts[:format]
      when :long
        " Part "
      when :abbrev
        " Pt. "
      when :short, :mr
        "pt"
      end + part
    end

    def render_supplement(supplement, opts, _params)
      case opts[:format]
      when :long
        " Supplement "
      when :abbrev
        " Suppl. "
      when :short, :mr
        "sup"
      end + supplement
    end

    def render_appendix(appendix, opts, _params)
      case opts[:format]
      when :long
        " Appendix "
      when :abbrev
        " App. "
      when :short, :mr
        "app"
      end
    end

    def render_section(section, opts, _params)
      case opts[:format]
      when :long
        " Section "
      when :abbrev
        " Sec. "
      when :short, :mr
        "sec"
      end + section
    end

    def render_errata(errata, opts, _params)
      case opts[:format]
      when :long
        " Errata "
      when :abbrev
        " Err. "
      when :short, :mr
        "err"
      end
    end

    def render_index(index, opts, _params)
      case opts[:format]
      when :long
        " Index "
      when :abbrev
        " Index. "
      when :short, :mr
        "indx"
      end
    end

    def render_insert(insert, opts, _params)
      case opts[:format]
      when :long
        " Insert "
      when :abbrev
        " Ins. "
      when :short, :mr
        "ins"
      end
    end

    def render_stage(stage, opts, _params)
      case opts[:format]
      when :mr
        "."
      when :short
        ""
      else
        " "
      end + stage.to_s(opts[:format])
    end
  end
end
