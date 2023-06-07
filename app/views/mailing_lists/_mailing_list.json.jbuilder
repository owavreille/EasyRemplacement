json.extract! mailing_list, :id, :name, :text
json.url mailing_list_url(mailing_list, format: :json)
json.text mailing_list.text.to_s
