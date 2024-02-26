"use client";
import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import {
  createClientComponentClient,
  User,
} from "@supabase/auth-helpers-nextjs";
import { Database } from "@/supabase";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

export default function AuthForm({ user }: { user: User | null }) {
  const supabase = createClientComponentClient<Database>();
  const router = useRouter();
  const [queueRefresh, setQueueRefresh] = useState(false);

  useEffect(() => {
    if (!queueRefresh) return;
    setTimeout(() => {
      setQueueRefresh(false);
      router.refresh();
    }, 100);
  }, [queueRefresh, router]);

  supabase.auth.onAuthStateChange((event, session) => {
    if (["SIGNED_IN", "SIGNED_OUT"].includes(event)) setQueueRefresh(true);
  });
  const signOut = async () => {
    await supabase.auth.signOut({ scope: "global" });
  };

  return user ? (
    <button className="button block" onClick={signOut}>
      Sign out
    </button>
  ) : (
    <Auth
      supabaseClient={supabase}
      view="sign_in"
      theme="dark"
      appearance={{ theme: ThemeSupa }}
      providers={["google"]}
      onlyThirdPartyProviders
    />
  );
}
