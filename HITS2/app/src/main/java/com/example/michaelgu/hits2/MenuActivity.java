package com.example.michaelgu.hits2;

import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;

import static android.graphics.Color.parseColor;


public class MenuActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu);
        findViewById(R.id.pickup_button).setOnClickListener(launchPickup);
        findViewById(R.id.delivery_button).setOnClickListener(launchDelivery);

        ImageView logo = (ImageView)findViewById(R.id.menu_logo);
        logo.setImageResource(R.drawable.hits_logo);

        //configure the actionbar
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(parseColor("#D32F2F")));
        getSupportActionBar().setTitle("");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private final View.OnClickListener launchPickup = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            Intent pickupIntent = new Intent(MenuActivity.this, PickupActivity.class);
            startActivity(pickupIntent);
        }
    };

    private final View.OnClickListener launchDelivery = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Intent deliveryIntent = new Intent(MenuActivity.this, DeliveryActivity.class);
            startActivity(deliveryIntent);
        }
    };

}
