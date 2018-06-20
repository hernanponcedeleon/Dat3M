package porthosc.app.modules;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


public class JsonVerdictStringifier implements IAppVerdictStringifier {
    private final Gson gson;

    public boolean prettyPrinting = true;

    public JsonVerdictStringifier() {
        GsonBuilder builder = new GsonBuilder();
        if (prettyPrinting) {
            builder.setPrettyPrinting();
        }

        gson = builder.create();
    }

    @Override
    public String stringify(AppVerdict verdict) {
        return gson.toJson(verdict);
    }
}
