require 'sqlite3'

db = SQLite3::Database.new("./chinook.db")
customer_id=0
loop do
    puts "Enter the customer first name"
    first_name=gets.chomp
    puts "Enter the customer last name"
    last_name=gets.chomp
    customer_id_array=db.execute('SELECT CustomerId FROM customers WHERE FirstName=? AND LastName=?',[first_name,last_name])
    if customer_id_array.length==1
        customer_id=customer_id_array[0][0]
        break
    end
    puts "The customer name was invalid, so try again."
end
puts "The customer id was " + customer_id.to_s
track_id=0
loop do
    puts "Enter the name of the track the customer wants"
    track_name=gets.chomp
    track_id_array=db.execute('SELECT TrackId FROM tracks WHERE NAME=?',[track_name])
    if track_id_array.length==1
        track_id=track_id_array[0][0]
        break
    end
    puts "The track name was not found, so try again"
end
puts "The track ID was " + track_id.to_s
db.execute('INSERT INTO invoices (InvoiceDate,CustomerId,Total) VALUES (?,?,0.99)',[Time.now.strftime('%F %T'),customer_id])
invoice_id=db.last_insert_row_id
puts "The invoice ID was " + invoice_id.to_s
record_array=db.execute('SELECT * FROM invoices WHERE InvoiceID=?',[invoice_id])
puts record_array[0].to_s
# db.execute('DELETE FROM invoices WHERE InvoiceId=?',[invoice_id])
db.execute('INSERT INTO invoice_items (InvoiceId,TrackId,UnitPrice,Quantity) VALUES(?,?,0.99,1)',[invoice_id,track_id])
puts "The order was completed."
invoice_items_id=db.last_insert_row_id
puts "The invoice line id was " + invoice_items_id.to_s
record_array=db.execute('SELECT * FROM invoice_items WHERE InvoiceLineId=?',[invoice_items_id])
#puts "array size " + record_array.length.to_s
puts record_array[0].to_s