class CreateAirlineContents < ActiveRecord::Migration[5.1]
  def change
    create_table :airline_contents do |t|
      t.string :carrier_code
      t.string :carrier_name
      t.string :country_code
      t.text :content_en_in
      t.text :content_en_ae
      t.text :content_en_sa
      t.text :content_en_bh
      t.text :content_en_kw
      t.text :content_en_qa
      t.text :content_en_om
      t.text :content_hi_in
      t.text :content_ar_ae
      t.text :content_ar_sa
      t.text :content_ar_bh
      t.text :content_ar_kw
      t.text :content_ar_qa
      t.text :content_ar_om

      t.timestamps
    end
  end
end
