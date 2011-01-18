$(document).ready(function() {   

    var input = $('#adoption_dollar_fee');	
	input.focus(function() {
		if(input.val() == 0) {
			input.val('');
		}
	});
    input.keyup(function() {
        calculateDuckCount(input.val());
    });
    calculateDuckCount(input.val());
});
//recieves a price in dollars
function calculateDuckCount(price) {
    cents_price = price*100;
    pricing_rule = retrieve_pricing_rule(cents_price);
    //if the user has donated enough to get one or more ducks
    if(pricing_rule) {
        calculated_ducks = Math.floor(cents_price/pricing_rule['price']);
        $('#ducks_adopted').val(calculated_ducks);
        $('#amount_for_adoption').val(calculated_ducks*pricing_rule['price']/100);
        remainder = price-$('#amount_for_adoption').val();
        remainder = Math.round(remainder*Math.pow(10,2))/Math.pow(10,2);
        $('#cash_donation').val(remainder);

    }else{
        $('#ducks_adopted').val(0);
        $('#amount_for_adoption').val(0);
        $('#cash_donation').val(price);
    }
    $('#adoption_duck_count').val($('#ducks_adopted').val());
}
function retrieve_pricing_rule(price) {
    var pricings = pricingScheme.getPricings();
    var pricing_rule;
    var index=0;
    //while the correct pricing rule hasn't been found
    while(pricing_rule == null) {
        //retrieve the next pricing rule in the pricing rules list
        t_pricing_rule = pricings[index];
        //break the loop if there are no more pricing rules
        if(!t_pricing_rule) {            
            break;
        }
        //if the amount donated is greater than or equals to the minimum amount required to enter this pricing bracket
        //then we've found the correct pricing rule.
        if( price >= ((t_pricing_rule['quantity']+1) * t_pricing_rule['price'])  ) {
            pricing_rule = t_pricing_rule;            
        }
        index++;
    }    
    return pricing_rule;
}
