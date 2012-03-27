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

    // run calculateDuckCount an initial time for any pre-entered values.
    calculateDuckCount(input.val());
});
//recieves a price in dollars
function calculateDuckCount(price) {
    cents_price = price*100;
    pricing_rule = retrieve_pricing_rule(cents_price);


    // HACK!
    // Due to brochure screw-up, the brochure says you can adopt 24 ducks for 100 dlls
    // and 11 ducks for 50 dlls despite the math not adding up. To keep true to the brochure's
    // promise, we've hardcoded this exception for the pricing scheme logic when those two values
    // are entered.
    if(cents_price >= 10000 && cents_price <=10008) {
        $("#ducks_adopted").val(24);
        $('#amount_for_adoption').val(price);
        $("#cash_donation").val(0);
        $('#adoption_duck_count').val($('#ducks_adopted').val());
        return;
    }

    if(cents_price >= 5000 && cents_price <= 5005) {
        $("#ducks_adopted").val(11);
        $('#amount_for_adoption').val(price);
        $("#cash_donation").val(0);
        $('#adoption_duck_count').val($('#ducks_adopted').val());
        return;
    }
    // ENDHACK

    //if the user has donated enough to get one or more ducks
    // (pricing_rule will be null if the amount of dlls isn't enough to fit in any of the pricings)
    if(pricing_rule) {
        calculated_ducks = Math.floor(cents_price/pricing_rule['price']);
        $('#ducks_adopted').val(calculated_ducks);
        $('#amount_for_adoption').val(calculated_ducks*pricing_rule['price']/100);
        remainder = price-$('#amount_for_adoption').val();
        remainder = Math.round(remainder*Math.pow(10,2))/Math.pow(10,2);
        $('#cash_donation').val(remainder);

    } else {
    // otherwise all money goes as cash donation.
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
