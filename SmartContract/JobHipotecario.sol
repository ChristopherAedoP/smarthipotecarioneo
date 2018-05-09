using Neo.SmartContract.Framework;
using Neo.SmartContract.Framework.Services.Neo;

namespace Neo.SmartContract
{
    public class dominio : Framework.SmartContract
    {
        
        public static readonly byte[] Owner1 = "ATrzHaicmhRj15C3Vv6e6gLfLqhSD2PtTr".ToScriptHash(); //Banco
        public static readonly byte[] Owner2 = "ksjsh3434GekkwHkewrjeDjjjhhhehe".ToScriptHash(); // Ejecutivo Hipotecario
        public static readonly byte[] Owner3 = "LSDKF6KSDKJJJksjhsdfsshdggd".ToScriptHash();  // Notaria
        public static readonly byte[] Owner4 = "ssfdfghhJHggfffdDDFHJJJHGFg".ToScriptHash(); // CBRS
        public static readonly byte[] Owner5 = "2k2h2gksjhshgsgsgsggfffdfsss".ToScriptHash(); // INMOBILIARIA - FINALIZA SOLICITUD - FIN DEL PROCESO
        
        public static object Main(string operation, params object[] args)
        {
            switch (operation)
            {
                //Usuario consulta el estado de su credito
                case "ConsultarEstadoCredito":

                    if (args.Length != 1) return 0;
                    byte[] EstadoHipo = (byte[])args[0];
                    return Consulta(EstadoHipo);
                //Inicia la solicitud de Hipotecario (Banco)
                case "IngresarHipoInicial":

                    return IngresarHipoInicial((string)args[0], (byte[])args[1]); // Arg[0] = 
              
                //Traspaso el trabajo a otra entidad (Siguiente en el proceso hipotecario)
                case "TraspasarSolProceso":
                   if (args.Length != 3) return false;
                    byte[] from = (byte[])args[0];    // Entidad 1
                    byte[] to = (byte[])args[1];      // Entidad 2
                    Integer IdOperacion = (Integer)args[2]; // Id de operacion 

                    return Transfiere((from, to, IdOperacion); 
                //case "Eliminar":
                 //   return Delete((string)args[0]);
                default:
                    return false;
            }
        }

        private static byte[] Consulta(byte[] address) // Consulto estado de progreso (Entidad quien la tiene)
        {
             return Storage.Get(Storage.CurrentContext, address).AsInteger();
        }

        private static bool IngresarHipoInicial(string dominio, byte[] owner)
        {
            if (!Runtime.CheckWitness(owner)) return false;
            byte[] value = Storage.Get(Storage.CurrentContext, dominio);
            if (value != null) return false;
            Storage.Put(Storage.CurrentContext, owner ,dominio );
            return true;
        }

       private static bool Transfer(byte[] from, byte[] to, BigInteger value)
        {
            if (!Runtime.CheckWitness(to)) return false;
            byte[] from = Storage.Get(Storage.CurrentContext, dominio);
            if (from == null) return false;
            if (!Runtime.CheckWitness(from)) return false;
            Storage.Put(Storage.CurrentContext, dominio, to);
            return true;
        }

      // private static bool Delete(string dominio)
      //    {
      //      byte[] owner = Storage.Get(Storage.CurrentContext, dominio);
      //    if (owner == null) return false;
      //   if (!Runtime.CheckWitness(owner)) return false;
      // Storage.Delete(Storage.CurrentContext, dominio);
      //return true;
      //}
    }
}
