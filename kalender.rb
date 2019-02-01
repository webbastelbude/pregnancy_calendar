require 'icalendar'
require 'rubygems'
require 'active_support/all'
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 1234

get '/:date.ics' do
  # Create a calendar with an event (standard method)
  cal = Icalendar::Calendar.new

  end_date = Date.new(2019,9,15)
  start_date = end_date - 40.weeks
  cwday = end_date.cwday
  week = -1
  day = 0
  month = 0

  ((end_date-40.weeks)..end_date).each do |date|
    day += 1
    if date.cwday == cwday
      week += 1
      day = 0
      month += 1 if week % 4 == 0
    end

    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateOrDateTime.new(date.strftime("%Y%m%d")).call
    event.dtend = Icalendar::Values::DateOrDateTime.new(date.strftime("%Y%m%d")).call
    event.summary = "#{month}. M #{week+1}. SSW (#{week}+#{day})"
    event.description = "#{month}. Monat\n#{week+1}. SSW (#{week}+#{day})"
    cal.add_event(event)
  end
  
  cal.add_event(get_event(start_date,  1,  6, "Wechsel der Lohnsteuerklasse prüfen"))    
  cal.add_event(get_event(start_date,  7, 10, "Krankenkassenleistungen prüfen / wechseln"))
  cal.add_event(get_event(start_date, 10, 16, "Hebammensuche"))
  cal.add_event(get_event(start_date, 13, 14, "Arbeitgeber über Schwangerschaft informieren"))
  cal.add_event(get_event(start_date, 13, 20, "Nabelschnurblut Einlagerung klären"))
  cal.add_event(get_event(start_date, 16, 22, "Anmeldung für Geburtsvorbereitungskurs"))
  cal.add_event(get_event(start_date, 16, 30, "Besichtigung + Anmeldung Krankenhaus"))
  cal.add_event(get_event(start_date, 18, 24, "Sorgeerklärung beim Jugendamt"))
  cal.add_event(get_event(start_date, 18, 24, "Vaterschaftsanerkennung"))
  cal.add_event(get_event(start_date, 23, 25, "Schwangerschaftsbescheinigung für Krankenkasse"))
  cal.add_event(get_event(start_date, 24, 25, "Antrag auf Mutterschaftsgeld"))
  cal.add_event(get_event(start_date, 25, 40, "Kinderarztsuche"))
  cal.add_event(get_event(start_date, 26, 40, "Kita oder Tagesbetreuung suchen"))
  cal.add_event(get_event(start_date, 26, 32, "Baby Erstaustattung kaufen / leihen"))
  cal.add_event(get_event(start_date, 30, 40, "Ggf. Haushaltshilfe suchen"))
  cal.add_event(get_event(start_date, 31, 33, "Antrag auf Elternzeit"))
  cal.add_event(get_event(start_date, 31, 37, "Taufe vorbereiten, sofern geplant"))
  cal.add_event(get_event(start_date, 35, 36, "Kliniktasche packen"))
  cal.add_event(get_event(start_date, 35, 40, "Antrag auf Kindergeld vorbereiten"))
  cal.add_event(get_event(start_date, 35, 40, "Antrag auf Elterngeld vorbereiten"))
  cal.add_event(get_event(start_date, 35, 40, "Mutterschutz"))

  cal.add_event(get_event(start_date,  5,  5, "Schwangerschaftstest nun aussagekräftig"))
  cal.add_event(get_event(start_date,  5,  7, "Erstuntersuchung beim Frauenarzt"))
  cal.add_event(get_event(start_date,  9, 12, "1. Ultraschalluntersuchung"))
  cal.add_event(get_event(start_date, 10, 13, "Impfschutz prüfen lassen"))
  cal.add_event(get_event(start_date, 12, 14, "Ersttrimesterscreening"))
  cal.add_event(get_event(start_date, 15, 18, "Ggf. Fruchtwasseruntersuchung"))
  cal.add_event(get_event(start_date, 19, 22, "2. Ultraschalluntersuchung"))
  cal.add_event(get_event(start_date, 24, 28, "Screening auf Schwangerschaftsdiabetes"))
  cal.add_event(get_event(start_date, 29, 33, "3. Ultraschalluntersuchung"))
  cal.add_event(get_event(start_date, 30, 36, "Geburtsvorbereitungskurs"))
  cal.add_event(get_event(start_date, 32, 32, "Blutuntersuchungen (Hepatitis B)"))
  cal.add_event(get_event(start_date, 36, 36, "Abstrich auf B-Streptokokken"))
  
  content_type "text/calendar"
  cal.to_ical
end

def get_event( start_date, start_ssw, end_ssw, event_summary)
  event = Icalendar::Event.new
  date_start = (start_date + (start_ssw - 1).weeks)
  date_end = (date_start + (end_ssw - start_ssw).weeks)
  event.dtstart = Icalendar::Values::DateOrDateTime.new(date_start.strftime("%Y%m%d")).call
  event.dtend = Icalendar::Values::DateOrDateTime.new(date_end.strftime("%Y%m%d")).call
  event.summary = event_summary
  return event
end

