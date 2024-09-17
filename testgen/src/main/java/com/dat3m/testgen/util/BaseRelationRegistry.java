package com.dat3m.testgen.util;

import com.dat3m.testgen.explore.WmmExplorer;

public class BaseRelationRegistry {

    public static void register_auto(
        final WmmExplorer wmm_explorer,
        final String cat_file
    ) throws Exception {
        switch( cat_file ) {
            case "sc.cat":
                register_sc( wmm_explorer );
            break;

            case "vmm-simplified-v2.cat":
                register_vmm_simplified_v2( wmm_explorer );
            break;

            case "andrej.cat":
                register_sc( wmm_explorer );
            break;

            default:
                System.out.println( "[ERROR] " + cat_file );
                throw new Exception( "No base relations registered for chosen cat file!" );
        }
    }
    
    static void register_sc(
        final WmmExplorer wmm_explorer
    ) throws Exception {
        wmm_explorer.register_base_relation( "po",    Types.base.po    );
        wmm_explorer.register_base_relation( "co",    Types.base.co    );
        wmm_explorer.register_base_relation( "rf",    Types.base.rf    );
        wmm_explorer.register_base_relation( "ext",   Types.base.ext   );
        wmm_explorer.register_base_relation( "rmw",   Types.base.rmw   );
        wmm_explorer.register_base_relation( "[R]",   Types.base.read  );
        wmm_explorer.register_base_relation( "[W]",   Types.base.write );
        wmm_explorer.register_base_relation( "[RMW]", Types.base.rmw   );

        wmm_explorer.register_ignored_relation( "((([R]) \\ ([range(rf)])) ; loc) ; ([W])" );
    }

    static void register_vmm_simplified_v2(
        final WmmExplorer wmm_explorer
    ) throws Exception {
        wmm_explorer.register_base_relation( "co",  Types.base.co );
        wmm_explorer.register_base_relation( "rf",  Types.base.rf );
        wmm_explorer.register_base_relation( "po",  Types.base.po );
        wmm_explorer.register_base_relation( "loc", Types.base.loc );

        wmm_explorer.register_ignored_relation( "((([R]) \\ ([range(rf)])) ; loc) ; ([W])" );
    }

}
