sed -n '/t_marketplace_invoice/,/ENGINE=/p' assets/model/install.sql | sed -e 's/\/\*TABLE_PREFIX\*\//oc_/g'
